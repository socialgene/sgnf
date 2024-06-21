# Changelog

## [0.4.5](https://github.com/socialgene/sgnf/compare/v0.4.4...v0.4.5) (2024-06-21)


### Miscellaneous Chores

* release 0.4.5 ([cde59ae](https://github.com/socialgene/sgnf/commit/cde59ae77bb8635f934d274580ee780503e0236c))

## [0.4.4](https://github.com/socialgene/sgnf/compare/v0.4.3...v0.4.4) (2024-02-22)


### Miscellaneous Chores

* release 0.4.3 ([50fba0c](https://github.com/socialgene/sgnf/commit/50fba0cbb36bf0fa21ff11cbcad4699a2732d03e))
* release 0.4.4 ([03c4d6c](https://github.com/socialgene/sgnf/commit/03c4d6cf08980da338caa720e7c111e6f74b1119))

## [0.4.3](https://github.com/socialgene/sgnf/compare/v0.4.2...v0.4.3) (2024-02-22)


### Bug Fixes

* alpine doesn't play well with aws/nextflow ([8bfc30a](https://github.com/socialgene/sgnf/commit/8bfc30ae7d178652f72860ef875312ae7567b51a))
* docker container specification ([65f2d7d](https://github.com/socialgene/sgnf/commit/65f2d7daedc1f852a281e3371321898f97a5f431))
* ncbi datasets renaming ([fb4bb7e](https://github.com/socialgene/sgnf/commit/fb4bb7ebc0d15723366c0ee85f7a269b83553507))
* orthologs.config ([e50dafd](https://github.com/socialgene/sgnf/commit/e50dafd6fdbcf2e02065ed53c74768fd1dd49ad7))
* params.antismash_fulljson ([d2e4348](https://github.com/socialgene/sgnf/commit/d2e4348bf6fa27edf56bf220c9b3ba4724b6c580))
* restore storeDir, was issue with alpine based container ([93c77c9](https://github.com/socialgene/sgnf/commit/93c77c90fed435cab293ce37cf7e65ebbf5b07a1))
* update schema ([ed493ee](https://github.com/socialgene/sgnf/commit/ed493eecbb81aae4401f7afd0ae895d475b95bde))

## [0.4.2](https://github.com/socialgene/sgnf/compare/v0.4.1...v0.4.2) (2023-12-08)

### Bug Fixes

- fixes [#89](https://github.com/socialgene/sgnf/issues/89) ([0f1ce5c](https://github.com/socialgene/sgnf/commit/0f1ce5cb20ddbb5868e8b534aa4de6d9400a69f9))

## [0.4.1](https://github.com/socialgene/sgnf/compare/v0.4.0...v0.4.1) (2023-11-18)

### Bug Fixes

- change from tar to gz ([7dde2fd](https://github.com/socialgene/sgnf/commit/7dde2fdb72e1d5114ed8a0ddf981357205e0c75d))

## [0.4.0](https://github.com/socialgene/sgnf/compare/v0.3.12...v0.4.0) (2023-11-18)

### Features

- antismash 7 ([8178835](https://github.com/socialgene/sgnf/commit/8178835f9033d67100f20dc8073a3a056d6c6f18))

### Bug Fixes

- deprecate 6.1 antismash ([bda70d0](https://github.com/socialgene/sgnf/commit/bda70d0c7a319dead3d30f7adee83961268955bc))

## [0.3.12](https://github.com/socialgene/sgnf/compare/v0.3.11...v0.3.12) (2023-11-17)

### Bug Fixes

- hmmparse ([4c771b9](https://github.com/socialgene/sgnf/commit/4c771b9d073b3cab699201bb9f4df6e284b55d18))

## [0.3.11](https://github.com/socialgene/sgnf/compare/v0.3.10...v0.3.11) (2023-11-17)

### Bug Fixes

- update hmmsearch parsing ([7cc82b0](https://github.com/socialgene/sgnf/commit/7cc82b007270dba5f12887a237f0a3f3bd7eccd5))

## [0.3.10](https://github.com/socialgene/sgnf/compare/v0.3.9...v0.3.10) (2023-11-17)

### Miscellaneous Chores

- release 0.3.10 ([2a06777](https://github.com/socialgene/sgnf/commit/2a0677723337b0a2b09d44dd1d7e101a408a3f45))

## [0.3.9](https://github.com/socialgene/sgnf/compare/v0.3.8...v0.3.9) (2023-11-17)

### Bug Fixes

- . ([227eed0](https://github.com/socialgene/sgnf/commit/227eed0bca1a7192c3f63b64d68f260e8c0071bc))
- add control for HMMSEARCH_IEVALUE in hmmsearch parse ([0b5cf04](https://github.com/socialgene/sgnf/commit/0b5cf0432a9b6bd2aea43a56c23f51bd1dfa5320))
- add job length to hcondor stdout ([a3741db](https://github.com/socialgene/sgnf/commit/a3741dbb16ece9c20594f32a63f16b31bb0d95d1))
- add std cov for mmseqs ([9745704](https://github.com/socialgene/sgnf/commit/974570492907cb2f816f2a83356bb68d344e6549))
- switch ncbi ftp to https ([7c3eb17](https://github.com/socialgene/sgnf/commit/7c3eb175b8a41d985365e0bd6bc6cb634a280a21))

## [0.3.8](https://github.com/socialgene/sgnf/compare/v0.3.7...v0.3.8) (2023-11-10)

### Bug Fixes

- add option to not store antismash tar ([63ab839](https://github.com/socialgene/sgnf/commit/63ab839a17db138274e8775ef0033918cefec4f4))

## [0.3.7](https://github.com/socialgene/sgnf/compare/v0.3.6...v0.3.7) (2023-11-10)

### Bug Fixes

- slurm overwrite in custom configs ([f13c77f](https://github.com/socialgene/sgnf/commit/f13c77f3971a708903342fbc2c29813cd4ed004a))

## [0.3.6](https://github.com/socialgene/sgnf/compare/v0.3.5...v0.3.6) (2023-11-10)

### Miscellaneous Chores

- release 0.3.6 ([b569cea](https://github.com/socialgene/sgnf/commit/b569cea155792807053d35a1d665a9e375aa60cc))

## [0.3.5](https://github.com/socialgene/sgnf/compare/v0.3.4...v0.3.5) (2023-11-10)

### Bug Fixes

- add antismash version to reports ([fc59e1c](https://github.com/socialgene/sgnf/commit/fc59e1c658f0e8426de06ca37308ad6ecf5e3239))
- ncbi datasets ([138c9b8](https://github.com/socialgene/sgnf/commit/138c9b8fa0c2dd3c0a0b5de01a773fd4d3bfd630))

## [0.3.4](https://github.com/socialgene/sgnf/compare/v0.3.3...v0.3.4) (2023-11-10)

### Bug Fixes

- move antismash cpus and mem to config ([1a74e81](https://github.com/socialgene/sgnf/commit/1a74e81ed09da0dd72bdc7803c9b4fe05082bbe7))
- prevent antismash from erroring on seqs w/o proteins ([f7065d0](https://github.com/socialgene/sgnf/commit/f7065d0361cda8496e51e7aa5f023e2a810c2e76))
- remove and comment out currently unused computation ([7677748](https://github.com/socialgene/sgnf/commit/7677748e0c30b883abae20d7c1c18c79ca290c4c))
- update strep config ([ddd2299](https://github.com/socialgene/sgnf/commit/ddd2299357ddaaaae20145dee861f4f5fb34f901))

## [0.3.3](https://github.com/socialgene/sgnf/compare/v0.3.2...v0.3.3) (2023-11-09)

### Bug Fixes

- neo4j docker Java must be pinned to jdk 17 ([25c0f32](https://github.com/socialgene/sgnf/commit/25c0f32c87eed59373ee3af582b57cb07ac2e8a0))
- rm datasets file input, and fix version output since it changed in v15 ([d2c4d90](https://github.com/socialgene/sgnf/commit/d2c4d9070d45d2841099ee86715cb9d013d80726))

## [0.3.2](https://github.com/socialgene/sgnf/compare/v0.3.1...v0.3.2) (2023-11-08)

### Bug Fixes

- release-please ([682a161](https://github.com/socialgene/sgnf/commit/682a1612dbc4d6cfed6d3de082eb0db0f5e389c8))

### Miscellaneous Chores

- release 0.3.2 ([53f839f](https://github.com/socialgene/sgnf/commit/53f839faee7eb53ed786f9809df2250015d4c32b))

## [0.3.1](https://github.com/socialgene/sgnf/compare/v0.3.0...v0.3.1) (2023-11-08)

### Bug Fixes

- docker sgpy-base ([#71](https://github.com/socialgene/sgnf/issues/71)) ([ea26118](https://github.com/socialgene/sgnf/commit/ea261186da643048d02b2b2a47a05f336eebedf9))

## [0.3.0](https://github.com/socialgene/sgnf/compare/v0.2.6...v0.3.0) (2023-11-08)

### Features

- new release ([#69](https://github.com/socialgene/sgnf/issues/69)) ([2ae0668](https://github.com/socialgene/sgnf/commit/2ae0668921ac0987b54ae5bd5c710d9f2df6ca5c))

## [0.2.6](https://github.com/socialgene/sgnf/compare/v0.2.5...v0.2.6) (2023-10-14)

### Bug Fixes

- update ncbi dataset cli ([e3af2b8](https://github.com/socialgene/sgnf/commit/e3af2b876eabfd8d27ded5ea6fe8abf90097bba2))

## [0.2.5](https://github.com/socialgene/sgnf/compare/v0.2.4...v0.2.5) (2023-08-30)

### Bug Fixes

- args in mmseqs and change to comma-delimited ([5963bc7](https://github.com/socialgene/sgnf/commit/5963bc78cee22d9cdedf83fd0f3dfffd1375de79))
- mac compatibility ([e968c7b](https://github.com/socialgene/sgnf/commit/e968c7b3759471b90ec988867e4b78fce4be33b1))
- output an empty conf directory ([dce91cc](https://github.com/socialgene/sgnf/commit/dce91cc55cbb0e4619905ed3907e26247bb55cd2))

## [0.2.4](https://github.com/socialgene/sgnf/compare/v0.2.3...v0.2.4) (2023-07-03)

### Bug Fixes

- fix configs for nf-tower use ([364a40d](https://github.com/socialgene/sgnf/commit/364a40d485b34da5262232916a32786bf96dd3e1))

## [0.2.3](https://github.com/socialgene/sgnf/compare/v0.2.2...v0.2.3) (2023-07-03)

### Bug Fixes

- null hmmlist ([e65d199](https://github.com/socialgene/sgnf/commit/e65d1997da40a4d6a9c395373c07aeffcc4bf11e))

## [0.2.2](https://github.com/socialgene/sgnf/compare/v0.2.1...v0.2.2) (2023-07-03)

### Bug Fixes

- remove unused protein_info_table ([be4cb0d](https://github.com/socialgene/sgnf/commit/be4cb0d78d870c3628fbf74f840d2ca5a2f23c90))

## [0.2.1](https://github.com/socialgene/sgnf/compare/v0.2.0...v0.2.1) (2023-07-03)

### Bug Fixes

- bump sgpy version ([186c4b1](https://github.com/socialgene/sgnf/commit/186c4b11371762d6412f29589e336899ef4d0bb2))

## [0.2.0](https://github.com/socialgene/sgnf/compare/v0.1.7...v0.2.0) (2023-07-03)

### Features

- ([#57](https://github.com/socialgene/sgnf/issues/57)) ([5fba835](https://github.com/socialgene/sgnf/commit/5fba835979d153b8b8bcf669783f876c30081856))

## [0.1.7](https://github.com/socialgene/sgnf/compare/v0.1.6...v0.1.7) (2023-07-03)

### Bug Fixes

- bump sgpy ([6e3d05d](https://github.com/socialgene/sgnf/commit/6e3d05d05a0f04531ee3a1a5c33e05aa2d112ccb))

## [0.1.6](https://github.com/socialgene/sgnf/compare/v0.1.5...v0.1.6) (2023-07-02)

### Bug Fixes

- ([#54](https://github.com/socialgene/sgnf/issues/54)) ([1610368](https://github.com/socialgene/sgnf/commit/1610368414004983d6cdfa1942fb1cf97b2613e9))

## [0.1.5](https://github.com/socialgene/sgnf/compare/v0.1.4...v0.1.5) (2023-06-22)

### Bug Fixes

- antismash and numeric types ([#49](https://github.com/socialgene/sgnf/issues/49)) ([744d955](https://github.com/socialgene/sgnf/commit/744d9553cedb38a9ca0b695c9f38c112a63453aa))

## [0.1.4](https://github.com/socialgene/sgnf/compare/v0.1.3...v0.1.4) (2023-06-22)

### Bug Fixes

- antismash ([#47](https://github.com/socialgene/sgnf/issues/47)) ([8a22868](https://github.com/socialgene/sgnf/commit/8a22868360c9ac10994ef7d5649af25e5d829576))

## [0.1.3](https://github.com/socialgene/sgnf/compare/v0.1.2...v0.1.3) (2023-06-21)

### Bug Fixes

- bump sgpy ([99896f6](https://github.com/socialgene/sgnf/commit/99896f6a8454ab14b117da0155f39df9e93b3856))

## [0.1.2](https://github.com/socialgene/sgnf/compare/v0.1.1...v0.1.2) (2023-06-21)

### Bug Fixes

- change default cov id ([#44](https://github.com/socialgene/sgnf/issues/44)) ([b344521](https://github.com/socialgene/sgnf/commit/b34452195c4c30994f9f0197232c5d27a3f1d809))

## [0.1.1](https://github.com/socialgene/sgnf/compare/v0.1.0...v0.1.1) (2023-06-21)

### Bug Fixes

- python code for antismash.jsonl ([b97d5a2](https://github.com/socialgene/sgnf/commit/b97d5a27fb2c0f88d9df36a9939597069c3b7d92))

## [0.1.0](https://github.com/socialgene/sgnf/compare/v0.0.6...v0.1.0) (2023-06-21)

### Features

- create antismash.jsonl ([#41](https://github.com/socialgene/sgnf/issues/41)) ([3087f13](https://github.com/socialgene/sgnf/commit/3087f138422414dd132483cb94b66f0f7129f320))

## [0.0.6](https://github.com/socialgene/sgnf/compare/v0.0.5...v0.0.6) (2023-06-21)

### Bug Fixes

- linters ([#38](https://github.com/socialgene/sgnf/issues/38)) ([8cc0ceb](https://github.com/socialgene/sgnf/commit/8cc0ceb103a0ea20b2b32c8612df162a65a25eb2))

## [0.0.5](https://github.com/socialgene/sgnf/compare/v0.0.4...v0.0.5) (2023-06-19)

### Bug Fixes

- bump ([48a2b96](https://github.com/socialgene/sgnf/commit/48a2b963cfb9b85975386952a2cf8431d9362f5c))

## [0.0.4](https://github.com/socialgene/sgnf/compare/v0.0.3...v0.0.4) (2023-06-19)

### Bug Fixes

- bump sgpy version ([6a35a77](https://github.com/socialgene/sgnf/commit/6a35a77ce012bd509476926e21609cba4323e698))
- make default mmseqs id/cov the same as diamond ([003eff5](https://github.com/socialgene/sgnf/commit/003eff5d11febaab638d7997dbbb2c2c3f14871e))

## [0.0.3](https://github.com/socialgene/sgnf/compare/v0.0.2...v0.0.3) (2023-06-17)

### Bug Fixes

- add curl to minimal docker image ([0c5d47b](https://github.com/socialgene/sgnf/commit/0c5d47b6fa449fed67d4ce74aada9e503556b591))
- antismash docker call ([2abe262](https://github.com/socialgene/sgnf/commit/2abe262757a5040eebf8dc0c7f659f0f03a7ea7d))

## [0.0.2](https://github.com/socialgene/sgnf/compare/v0.0.1...v0.0.2) (2023-06-16)

### Bug Fixes

- change ncbi-genome-download docker ([295606b](https://github.com/socialgene/sgnf/commit/295606b66ee1ec861ba5eff6c71b6197b5ccdcd4))
- loosen accessory version pins in sgpy base docker ([ca94c3e](https://github.com/socialgene/sgnf/commit/ca94c3ec0cda3556fab7eb7d4cbef58d5b8bfbe8))
- ncbi-genome-download error ([f881373](https://github.com/socialgene/sgnf/commit/f881373cdd1bf3cf68c65cd2962e13e4b82a1834))
- socialgene is now on PyPI ([82af357](https://github.com/socialgene/sgnf/commit/82af3575e07ca8ddd5949640672f6205f74a2402))

## 0.0.1 (2023-06-15)

### Bug Fixes

- fixing lint ([31e4c0f](https://github.com/socialgene/sgnf/commit/31e4c0f1ee608b2216856014b092ef3fc8f1393a))
- reset release please ([b22acbb](https://github.com/socialgene/sgnf/commit/b22acbba3606e3eda124083d048067ed139e2bc8))

### Miscellaneous Chores

- release 0.0.1 ([9d1cf65](https://github.com/socialgene/sgnf/commit/9d1cf65873f05cbbe7fb00a986780678f5a5d704))
