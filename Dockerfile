FROM archlinux:latest
RUN pacman -Sy --noconfirm \
    git \
    curl \
    jq \
    nodejs
RUN git clone  --progress --verbose https://github.com/MostafaACHRAF/Git-MR /bin/gitmr
# COPY  . /bin/gitmr
RUN chmod +x /bin/gitmr/src/*.sh && chmod +x /bin/gitmr/git-mr && chmod 777 /bin/gitmr
RUN touch /root/.bashrc && echo "export PATH=/bin/gitmr:$PATH" >> /root.bashrc
RUN groupadd --gid 1000 user
RUN useradd  --uid 1000 --gid 1000 user
VOLUME /conf /workspace
WORKDIR /workspace
ENTRYPOINT [ "/bin/gitmr/git-mr" ]
USER user