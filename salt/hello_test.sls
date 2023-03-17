{% set name = pillar.get('name') %}

/home/user/hello.txt:
  file.managed:
    - contents: "hello {{ name }}!"
