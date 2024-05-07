FROM homebrew/brew:latest

RUN sudo apt-get update && \
    sudo  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 \
    virtualenv \
    git \
    pipx \
    wget && \
    sudo apt-get clean
RUN python3 -m pipx ensurepath
RUN python3 -m pipx completions

RUN brew install llvm uncrustify cppcheck include-what-you-use
RUN brew cleanup

RUN wget https://github.com/oclint/oclint/releases/download/v0.13.1/oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz \
    && sudo mkdir -p /opt/oclint-release \
    && sudo chown -R $(whoami) /opt/oclint-release \
    && tar xf oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz -C /opt/oclint-release --strip-components 1 \
    && rm oclint-0.13.1-x86_64-linux-4.4.0-112-generic.tar.gz \
    && sudo chmod +x /opt/oclint-release/bin/oclint

ENV OCLINT_HOME /opt/oclint-release
ENV PATH /home/linuxbrew/.local/bin:$OCLINT_HOME/bin:$PATH
# RUN echo 'PATH=$OCLINT_HOME/bin:$PATH' >> ~/.bashrc \
#     && ln -sf /usr/lib/libncursesw.so.6 /usr/lib/libtinfo.so.5

RUN pipx install CLinters
RUN pipx install cpplint
RUN pipx install clang-format

# make bash the default shell
RUN sudo ln -sf /bin/bash /bin/sh
