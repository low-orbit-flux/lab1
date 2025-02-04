FROM ubuntu
RUN apt update
RUN apt install -y python3
COPY index.html /
CMD /usr/bin/python3 -m http.server 8000

