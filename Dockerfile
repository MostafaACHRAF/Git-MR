FROM archlinux:latest
RUN pacman -Sy --noconfirm
RUN pacman -S --noconfirm git
RUN pacman -S --noconfirm curl
RUN pacman -S --noconfirm jq
RUN git clone  --progress --verbose https://github.com/MostafaACHRAF/Git-MR /bin/GitMR
RUN chmod +x /bin/GitMR/*.sh
RUN touch /root/.bashrc
RUN sh /bin/GitMR/linux-install.sh
WORKDIR /workspace
VOLUME /config /workspace