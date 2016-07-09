#!/bin/bash
make clean
make
zip -r BalonPerinKristoffersen.zip src lib classes run.sh Makefile
