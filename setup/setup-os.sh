#!/bin/sh

echo Setup OS

dnf -y update
dnf -y install expect

hostnamectl set-hostname testdocker.localdomain
