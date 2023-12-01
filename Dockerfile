FROM ubuntu:jammy

RUN apt -y update && apt install -y software-properties-common
RUN add-apt-repository -y ppa:rabbitmq/rabbitmq-erlang
RUN apt -y update && apt -y upgrade && apt -y install git vim jq elixir erlang-dev erlang-xmerl

CMD ["bash"]