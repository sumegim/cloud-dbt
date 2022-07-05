FROM ubuntu:latest
RUN mkdir /home/mark
ENV HOME /home/mark
WORKDIR $HOME

RUN apt-get update \
  && apt-get install -y  netcat-openbsd git curl locales build-essential \
    zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev \
    zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev liblzma-dev \
    libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev

RUN rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN git clone https://github.com/pyenv/pyenv.git .pyenv

ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install 3.9.2
RUN pyenv global 3.9.2
RUN pyenv rehash
RUN python -m pip install --upgrade pip

WORKDIR /dbt

COPY requirements.txt dbt/dbt_project/

COPY profiles.yml /home/mark/.dbt/

RUN pip install markupsafe==2.0.1

RUN pip install -r dbt/dbt_project/requirements.txt

COPY . /dbt/dbt_project

WORKDIR /dbt/dbt_project

EXPOSE 3306

RUN dbt deps

CMD make run
