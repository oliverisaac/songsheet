# Generate the lyrics.js file
FROM alpine:latest AS builder

RUN apk add --no-cache jq bash curl

COPY generate-lyrics.sh /build/
COPY songs /build/songs

WORKDIR /build 

RUN /build/generate-lyrics.sh > /build/lyrics.js

# Used to actually serve the content
FROM nginx

COPY --from=builder /build/lyrics.js /usr/share/nginx/html/
COPY index.html style.css vue.js /usr/share/nginx/html/

# Update the cach busing string to use the current timestamp
RUN sed -i -e "s/CACHE_BUSTING_STRING/$( date +%s )/" /usr/share/nginx/html/index.html
