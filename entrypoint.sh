#!/bin/bash


/opt/mssql/bin/sqlservr &

sleep 30 && python3 app.py
