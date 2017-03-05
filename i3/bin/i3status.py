#!/usr/bin/env python3

from ctypes      import (cdll, get_errno, cast,
                         Structure, Union, POINTER, pointer,
                         c_ushort, c_ubyte, c_void_p, c_char_p,
                         c_uint, c_uint16, c_uint32)
from collections import deque
from functools   import reduce
from operator    import add
from socket      import AF_INET, AF_INET6, inet_ntop

import datetime
import json
import math
import os
import signal
import sys
import time

class struct_sockaddr(Structure):
    _fields_ = [
        ('sa_family', c_ushort),
        ('sa_data',   14 * c_ubyte),
    ]

class struct_sockaddr_in(Structure):
    _fields_ = [
        ('sin_family', c_ushort),
        ('sin_port',   c_uint16),
        ('sin_addr',   4 * c_ubyte),
    ]

class struct_sockaddr_in6(Structure):
    _fields_ = [
        ('sin6_family',   c_ushort),
        ('sin6_port',     c_uint16),
        ('sin6_flowinfo', c_uint32),
        ('sin6_addr',     16 * c_ubyte),
        ('sin6_scope_id', c_uint32),
    ]

class union_ifa_ifu(Union):
    _fields_ = [
        ('ifu_broadaddr', POINTER(struct_sockaddr)),
        ('ifu_dstaddr',   POINTER(struct_sockaddr)),
    ]

class struct_ifaddrs(Structure):
    # forward declaration for reference in 'ifa_next'
    pass

struct_ifaddrs._fields_ = [
    ('ifa_next',    POINTER(struct_ifaddrs)),
    ('ifa_name',    c_char_p),
    ('ifa_flags',   c_uint),
    ('ifa_addr',    POINTER(struct_sockaddr)),
    ('ifa_netmask', POINTER(struct_sockaddr)),
    ('ifa_ifu',     union_ifa_ifu),
    ('ifa_data',    c_void_p),
]

def format_address(sockaddr):
    if sockaddr.contents.sa_family == AF_INET:
        internet_address = cast(sockaddr, POINTER(struct_sockaddr_in))
        return inet_ntop(AF_INET, internet_address.contents.sin_addr)

    if sockaddr.contents.sa_family == AF_INET6:
        internet_address = cast(sockaddr, POINTER(struct_sockaddr_in6))
        return inet_ntop(AF_INET6, internet_address.contents.sin6_addr)

def num_bits_set(sockaddr):
    if sockaddr.contents.sa_family == AF_INET:
        internet_address = cast(sockaddr, POINTER(struct_sockaddr_in))
        address = internet_address.contents.sin_addr
        result = 0
        for byte in address:
            result += {
                0b11111111: 8,
                0b11111110: 7,
                0b11111100: 6,
                0b11111000: 5,
                0b11110000: 4,
                0b11100000: 3,
                0b11000000: 2,
                0b10000000: 1,
                0b00000000: 0,
            }[byte]
        return result

    if sockaddr.contents.sa_family == AF_INET6:
        internet_address = cast(sockaddr, POINTER(struct_sockaddr_in6))
        return inet_ntop(AF_INET6, internet_address.contents.sin6_addr)

def ifaddrs(name):
    name = name.encode('ASCII')
    libc = cdll.LoadLibrary('libc.so.6')

    interfaces = POINTER(struct_ifaddrs)()
    if libc.getifaddrs(pointer(interfaces)):
        raise OSError(get_errno())
    try:
        result = []
        interface = interfaces
        while interface:
            if interface.contents.ifa_name == name:
                address = interface.contents.ifa_addr
                if address.contents.sa_family == AF_INET:
                    address = format_address(address)
                    netmask = interface.contents.ifa_netmask
                    if netmask:
                        address += '/' + str(num_bits_set(netmask))
                    result.append(address)
            interface = interface.contents.ifa_next
        return result
    finally:
        libc.freeifaddrs(interfaces)

class CpuUsageMonitor:
    def _parse_num_cpus(self):
        with open('/proc/cpuinfo') as f:
            return len([line for line in f if line.startswith('processor')])

    def _parse_uptime(self):
        with open('/proc/uptime') as f:
            uptime, idletime = map(float, f.read().split())
            return uptime, idletime / self._num_cpus

    def __init__(self, window_size):
        self._num_cpus    = self._parse_num_cpus()
        self._window      = deque()
        self._window_size = window_size

    def update(self):
        self._window.append(self._parse_uptime())
        while self._window[-1][1] - self._window[0][1] > self._window_size:
            self._window.popleft()

    def usage(self):
        if len(self._window) < self._window_size:
            return 0
        first, last = self._window[0], self._window[-1]
        return 1 - (last[1] - first[1])/(last[0] - first[0])

class InterfaceTrafficMonitor:
    def _parse_dev(self):
        with open('/proc/net/dev') as f:
            for line in f:
                items = line.split()
                if items[0] != self._interface + ':':
                    continue

                return int(items[1]), int(items[9]), datetime.datetime.now()

    def __init__(self, interface):
        self._interface   = interface
        self._window      = deque()
        self._window_size = datetime.timedelta(0, 2)

    def update(self):
        self._window.append(self._parse_dev())
        while self._window[-1][2] - self._window[0][2] > self._window_size:
            self._window.popleft()

    def stats(self):
        if len(self._window) < 2:
            return 0, 0
        first, last = self._window[0], self._window[-1]
        time_delta = (last[2] - first[2]).total_seconds()
        received   = (last[0] - first[0])
        sent       = (last[1] - first[1])
        return received/time_delta, sent/time_delta

def cpu_thermal():
    root  = '/sys/devices/platform/coretemp.0/hwmon'
    paths = os.listdir(root)
    if len(paths) == 0:
        return
    path  = root + '/' + paths[0] + '/temp1_'
    temps = {}
    for suffix in ('input', 'max', 'crit'):
        with open(path + suffix) as f:
            temps[suffix] = float(f.read().strip())
    data = {
        'full_text': '{:0>2.0f} °C'.format(temps['input'] / 1000),
    }
    if temps['input'] > temps['max']:
        data['color'] = '#ff0000'
    return data

def cpu(monitor):
    usage = monitor.usage()
    text  = '{:0>2.0f}%'.format(100 * usage)
    data = {
        'full_text': text,
        'separator_block_width': 0,
    }
    if usage > 0.8:
        data['color'] = '#ff0000'
    return data

def interface_address(networks):
    data = {
        'full_text': ', '.join(networks),
    }
    if len(networks) == 0:
        data['color'] = '#ff0000'
    return data

def format_traffic(traffic):
    traffic = int(traffic)
    units = ['  B', 'KiB', 'MiB', 'GiB']

    traffic /= 1024
    power    = 1
    while traffic > 1024:
        traffic /= 1024
        power   += 1

    if traffic == 0:
        return '   0 KiB/s'

    exponent = int(math.log(traffic, 10))
    if exponent == 0:
        traffic = round(traffic, 2)
    elif exponent == 1:
        traffic = round(traffic, 1)
    else:
        traffic = round(traffic)

    return '{:>4} {}/s'.format(str(traffic), units[power])

def network_traffic(traffic_monitor, dir):
    traffic = traffic_monitor.stats()[0 if dir == 'down' else 1]
    direction = 'd' if dir == 'down' else 'u'
    data = {
        'full_text': '{} {}'.format(format_traffic(traffic), direction)
    }
    if traffic > 1024 * 1024:
        data['color'] = '#ff0000'
    return data

def datestring():
    return {
        'full_text': datetime.datetime.now().strftime('%a %d %b, %H:%M:%S')
    }

def separator():
    return {
        'full_text': '|',
        'color': '#888888',
    }

def text(string):
    return {
        'full_text': string,
        'separator_block_width': 0,
    }

def cpu_group(cpu_usage_monitor):
    return [
        text('CPU '),
        cpu(cpu_usage_monitor),
        text(', '),
        cpu_thermal(),
    ]

def net_group(interface, traffic_monitor):
    networks = ifaddrs(interface)
    result = []
    if len(networks) == 0:
        label = text(interface + ' ')
        label['color'] = '#ff0000'
        return [label]

    return [
        text(interface + ' '),
        interface_address(networks),
        text(': '),
        network_traffic(traffic_monitor, 'down'),
        text(', '),
        network_traffic(traffic_monitor, 'up'),
    ]

def status(cpu_usage_monitor, traffic_monitor):
    items = cpu_group(cpu_usage_monitor)         + [separator()] + \
            net_group('wlp4s0', traffic_monitor) + [separator()] + \
            [datestring()]
    for item in items:
        item['separator']             = False
        if 'separator_block_width' not in item:
            item['separator_block_width'] = 5
    return items

def write_object(obj):
    json.dump(obj, sys.stdout)
    sys.stdout.flush()

def write_header():
    write_object({
        'version': 1,
        'stop_signal': signal.SIGTSTP,
        'cont_signal': signal.SIGCONT,
    })

class Control:
    def __init__(self):
        self._print    = True
        self._continue = True

    def enable(self, _1, _2):
        self._print = True

    def disable(self, _1, _2):
        self._print = False

    def should_print(self):
        return self._print

    def stop(self, _1, _2):
        self._continue = False

    def should_run(self):
        return self._continue

control = Control()

signal.signal(signal.SIGTSTP, control.disable)
signal.signal(signal.SIGCONT, control.enable)
signal.signal(signal.SIGINT,  control.stop)
signal.signal(signal.SIGTERM, control.stop)

cpu_usage_monitor = CpuUsageMonitor(10)
traffic_monitor   = InterfaceTrafficMonitor('wlp4s0')

def loop():
    while control.should_run():
        cpu_usage_monitor.update()
        traffic_monitor.update()
        time.sleep(1)
        if control.should_print():
            sys.stdout.write(',')
            write_object(status(cpu_usage_monitor, traffic_monitor))

def main():
    write_header()
    sys.stdout.write('[')
    write_object(status(cpu_usage_monitor, traffic_monitor))
    try:
        loop()
    except KeyboardInterrupt:
        pass
    sys.stdout.write(']\n')

if __name__ == '__main__':
    main()

