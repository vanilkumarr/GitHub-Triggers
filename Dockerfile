FROM alpine:3.19

RUN echo "Hello from Docker CI" > /message.txt

CMD ["cat", "/message.txt"]
