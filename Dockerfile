FROM archlinux:latest
RUN pacman -Sy --noconfirm \
    git \
    curl \
    jq \
    node \
RUN git clone  --progress --verbose https://github.com/MostafaACHRAF/Git-MR /bin/GitMR
RUN chmod +x /bin/GitMR/*.sh && chmod +x /bin/GitMR/git-* && chmod 777 /bin/GitMR
RUN touch /root/.bashrc && echo "export PATH=/bin/GitMR:$PATH" >> /root.bashrc
RUN groupadd --gid 1000 user
RUN useradd  --uid 1000 --gid 1000 user
VOLUME /config /workspace
WORKDIR /workspace
ENTRYPOINT [ "/bin/GitMR/git-mr" ]
USER user