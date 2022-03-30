FROM mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04

# Switch to root to customize the container

ENV ACCEPT_EULA=Y
USER root



# Update and setup timezone

RUN apt-get update -y && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Kuala_Lumpur apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata



# Base Dependencies

RUN apt-get install -y curl lsb-core g++ gpg



# Python dependencies

RUN apt-get install -y python3 python3-pip python3-dev



# gcloud dependencies

RUN apt-get install -y apt-utils apt-transport-https ca-certificates
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y google-cloud-cli



# MSSQL Drivers ( and extra odbc drivers just incase )
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15#ubuntu18

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN apt-get install -y unixodbc-dev
RUN pip3 install pyodbc pymssql


# Setup our app
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

USER mssql
ENTRYPOINT /bin/bash ./entrypoint.sh
