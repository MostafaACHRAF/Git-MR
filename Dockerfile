FROM archlinux:latest

RUN pacman -Sy --noconfirm
RUN pacman -S --noconfirm git
RUN pacman -S --noconfirm curl
RUN pacman -S --noconfirm jq
RUN git clone  --progress --verbose https://github.com/MostafaACHRAF/Git-MR /bin/GitMR
RUN chmod +x /bin/GitMR/*.sh
WORKDIR /bin/GitMR
RUN touch /root/.bashrc
RUN ./linux-install.sh
# RUN ./linux-install.sh && echo "/usr/bin/jq" >> /root/.bashrc
# ENTRYPOINT [ "./git-mr" ]