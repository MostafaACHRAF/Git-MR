FROM archlinux:latest

# RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm git
RUN pacman -S --noconfirm curl
RUN git clone  --progress --verbose https://github.com/MostafaACHRAF/Git-MR /bin/GitMR
RUN chmod +x /bin/GitMR/*.sh
RUN touch /root/.bashrc
WORKDIR /bin/GitMR
RUN ./linux-install.sh