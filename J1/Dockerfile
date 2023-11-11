FROM --platform=linux/amd64 tiangolo/uwsgi-nginx-flask:python3.6
RUN pip install redis requests
ADD /azure-vote /app

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1