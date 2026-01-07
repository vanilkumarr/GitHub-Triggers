FROM alpine:3.19

RUN echo "Hello from Docker CI/CD" > /message.txt

CMD ["cat", "/message.txt"]
