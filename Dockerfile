# This is an internal Dockerfile for the Pluto "@bind server" for the simulation website. It runs all the sliders, buttons and camera inputs, so that you can interact with them directly on the website, without having to wait for binder or a local Pluto session.
# Take a look at https://github.com/JuliaPluto/PlutoSliderServer.jl for more info.

FROM julia:1.6.0

# HTTP port
EXPOSE 1234
RUN apt-get update -y && apt-get upgrade -y
# add a new user called "pluto"
RUN useradd -ms /bin/bash pluto
# set the current directory
WORKDIR /home/pluto
# run the rest of commands as pluto user
USER pluto
# copy the contents of the github repository into /home/pluto
COPY --chown=pluto . ${HOME}


# Initialize the julia project environment that will be used to run the bind server.
RUN julia --project=${HOME}/pluto-deployment-environment -e "import Pkg; Pkg.instantiate(); Pkg.precompile()"

# The "default command" for this docker thing.
CMD ["julia", "--project=/home/pluto/pluto-deployment-environment", "-e", "import PlutoSliderServer; PlutoSliderServer.run_directory(\".\"; SliderServer_port=1234 , SliderServer_host=\"0.0.0.0\")"]
