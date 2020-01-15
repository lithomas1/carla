#!/usr/bin/env python

# Copyright (c) 2019 Computer Vision Center (CVC) at the Universitat Autonoma de
# Barcelona (UAB).
#
# This work is licensed under the terms of the MIT license.
# For a copy, see <https://opensource.org/licenses/MIT>.

import glob
import os
import sys

try:
    sys.path.append(glob.glob('../carla/dist/carla-*%d.%d-%s.egg' % (
        sys.version_info.major,
        sys.version_info.minor,
        'win-amd64' if os.name == 'nt' else 'linux-x86_64'))[0])
except IndexError:
    pass

import carla
import argparse

argparser = argparse.ArgumentParser()
argparser.add_argument(
    '-f', '--file',
    metavar='F',
    default="",
    type=str,
    help='OpenDRIVE file')
args = argparser.parse_args()

# read the OpenDRIVE
try:
    f = open(args.file, "rt")
except:
    print("OpenDRIVE file not found!")
    exit(1)

data = f.read()
f.close()

# create the map with the OpenDRIVE content
m = carla.Map("t", data)
for i in range(120):
  # for j in range(-10, 10, 1):
  for j in range(0,1):
    print(i, j)
    w = m.get_waypoint_xodr(i, j, 0)
    # if (w):
      # print("Waypoint: %d, %d = (%f, %f, %f) (%f, %f, %f)" % (i, j, w.transform.location.x, w.transform.location.y, w.transform.location.z, w.transform.rotation.pitch, w.transform.rotation.yaw, w.transform.rotation.roll)),
