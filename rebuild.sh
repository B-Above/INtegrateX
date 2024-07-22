#!/usr/bin/env bash

# automatically restart the network

goduck playground clean &&
goduck init &&
goduck playground start