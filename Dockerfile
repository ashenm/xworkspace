FROM ashenm/workspace

# avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# vnc entrypoint
EXPOSE 5050

# install lxde
RUN sudo apt-get update && \
  sudo -E apt-get install --no-install-recommends --yes \
    lubuntu-core && \
  sudo -E apt-get dist-upgrade --yes && \
  sudo rm -rf /var/lib/apt/lists/*

# install vnc
RUN sudo apt-get update && \
  sudo -E apt-get install --yes \
    vnc4server \
    xfonts-75dpi \
    xfonts-100dpi \
    xfonts-scalable && \
  sudo rm -rf /var/lib/apt/lists/*

# TEMP
# avoid 'No session for pid x' error
RUN sudo sed -i_orig -e 's/polkit\/command=lxpolkit/polkit\/command=/g' \
  /etc/xdg/lxsession/Lubuntu/desktop.conf

# configure system
COPY xworkspace /

# spawn Xvnc
CMD ["bash", "-lc", "xworkspace"]
