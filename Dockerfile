FROM wbitt/network-multitool as base

# Set Prompt
ENV PS1="\u@\h:\w$ "
# Add alias to user profile
RUN echo "alias ll='ls -la'" >> /root/.bashrc