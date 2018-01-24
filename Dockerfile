FROM base/archlinux

MAINTAINER Pradeep Garigipati

RUN pacman -Sy
RUN pacman -q --needed --noconfirm -S base-devel git vim
RUN pacman -q -S expac yajl --noconfirm --needed
RUN gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
ENV PATH="/usr/bin/core_perl:${PATH}"
ENV EDITOR="vim"

RUN useradd -r -g wheel -m dev
RUN echo "dev ALL=(root) NOPASSWD: /usr/bin/pacman" > /etc/sudoers.d/devperm

USER dev
WORKDIR /home/dev
RUN mkdir ctemp
WORKDIR /home/dev/ctemp
RUN curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
RUN makepkg PKGBUILD --noconfirm --skippgpcheck
USER root
RUN pacman --noconfirm -U cower-*.pkg.tar.xz

USER dev
WORKDIR /home/dev
RUN mkdir ptemp
WORKDIR /home/dev/ptemp
RUN curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
RUN makepkg PKGBUILD --noconfirm --skippgpcheck
USER root
RUN pacman --noconfirm -U pacaur-*.pkg.tar.xz

RUN pacman -q --needed --noconfirm -S cmake freeimage fontconfig glfw-x11 freetype2 glm

USER dev
WORKDIR /home/dev
RUN rm -r ctemp ptemp
RUN pacaur -Sy
RUN pacaur -q --silent --needed --noconfirm --noedit -S glbinding

USER root
RUN pacman -q --needed --noconfirm -S cmake freeimage fontconfig glfw-x11 freetype2 glm
RUN pacman -q --needed --noconfirm -S fftw blas cblas lapack lapacke boost boost-libs
RUN pacman -q --needed --noconfirm -S cuda
RUN pacman -q --needed --noconfirm -S ocl-icd opencl-headers opencl-nvidia
