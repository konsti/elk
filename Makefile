NAME = propertybase/elk
BASEIMAGE_VERSION = 0.9.16
VERSION = 0.1.0

.PHONY: build \
				tag_latest release clean clean_images

build:
	rm -rf elk_image
	cp -pR image elk_image
	sed -i "s/VERSION/$(BASEIMAGE_VERSION)/" elk_image/Dockerfile
	docker build -t $(NAME):$(VERSION) --rm elk_image

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION)"

clean:
	rm -rf elk_image

clean_images:
	docker rmi propertybase/elk:latest propertybase/elk:$(VERSION) || true
