#!/usr/bin/env python3
from os import environ as env, system

from docker import Client
from docker.errors import APIError
from subprocess import check_output

preserved = {'registry-ui'}

cli = Client(base_url=env['DOCKER_HOST'])

print('Working on', env['DOCKER_HOST'])

stopped = [c for c in cli.containers(all=True) if c['State'] not in {'running', 'restarting'}]
for c in stopped:
    cli.remove_container(c['Id'])

containers_in_use = [c for c in cli.containers() if c['State'] == 'running']

images_in_use = {c['ImageID'] for c in containers_in_use}


def image_not_latest(img):
    for t in img['RepoTags'] or []:
        if t.endswith(':latest'):
            return False
    return True


def image_not_used(img):
    return not img['Id'] in images_in_use


images_to_del = [c['Id'] for c in cli.images(all=True) if image_not_latest(c) and image_not_used(c)]
deleted = set()

before = check_output(['df', '-h']).decode('utf-8').split('\n')[1:-1]
deletions = 1
while deletions > 0:
    deletions = 0
    for img in images_to_del:
        if img in deleted:
            print('skipping', img)
            continue
        try:
            cli.remove_image(img)
            deletions += 1
            images_to_del.remove(img)
            print('-------------- Removed', img)
            deleted.add(img)
        except APIError as e:
            if 'image has dependent child images' in str(e):
                print('Image', img, 'has childs')
            elif 'No such image' in str(e) and img in deleted:
                pass
            elif 'No such image' in str(e):
                print('Image', img, 'probably removed before')
            else:
                raise
        except Exception as e:
            print(e, img)

after = check_output(['df', '-h']).decode('utf-8').split('\n')[1:-1]

matrix = []
for i in range(0, len(after)):
    b = [d for d in before[i].split(' ') if len(d) > 0]
    if b[0][:5] != '/dev/': continue
    a = [d for d in after[i].split(' ') if len(d) > 0]
    line = '{}{}{}{}{}->{}\t{}->{}\t{}->{}' \
        .format(b[0], ' ' * (13 - len(b[0])), b[5], ' ' * (13 - len(b[5])), b[2], a[2], b[3], a[3], b[4], a[4])
    matrix.append(line)

print()
print('Diff:')
print('\n'.join(matrix))
