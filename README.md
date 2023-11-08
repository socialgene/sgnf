> Note: All releases may introduce breaking changes until the release of v1.0.0

[![Launch on Nextflow Tower](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Nextflow%20Tower-%234256e7)](https://tower.nf/launch?pipeline=https://github.com/socialgene/sgnf)
<!-- [![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX) -->
 <!-- [![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)  -->
<!-- [![GitHub Actions CI Status](https://github.com/socialgene/sgnf/workflows/nf-core%20CI/badge.svg)](https://github.com/socialgene/sgnf/actions?query=workflow%3A%22nf-core+CI%22)
[![GitHub Actions Linting Status](https://github.com/socialgene/sgnf/workflows/nf-core%20linting/badge.svg)](https://github.com/socialgene/sgnf/actions?query=workflow%3A%22nf-core+linting%22) -->

## Documentation

Can be found at https://socialgene.github.io

## Usage

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/) [![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)

:::note
If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how
to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline)
with `-profile test` before running the workflow on actual data.
:::

Note that this pipeline can initiate significant number of compute processes. If you are running on a cloud service you alone are responsible for any costs.

```bash
outdir="path_to_my/outdir"
outdir_download_cache="path_to_my/outdir_download_cache"

nextflow run  socialgene/sgnf \
  -profile ultraquickstart,docker \
  --outdir $outdir \
  --outdir_download_cache $outdir_download_cache
```

> Unlike nf-core hosted pipelines, you should be able to use configuration files to run the pipeline. A number of examples are available https://github.com/socialgene/sgnf/tree/main/conf/examples

## Credits

socialgene/sgnf was originally written by Chase M. Clark.

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

## Contributions and Support

Chase M. Clark (and thus this project) was supported by an NLM training grant to the Computation and Informatics in Biology and Medicine Training Program (NLM 5T15LM007359)

For further information or help, don't hesitate to get in touch on the [Slack `#socialgene/sgnf` channel](https://nfcore.slack.com/channels/socialgene/sgnf) (you can join with [this invite](https://nf-co.re/join/slack)).

## Citations

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

You can cite the `nf-core` publication as follows:

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).

# Docker Images

[![DockerPulls](https://img.shields.io/static/v1?logo=docker&label=&message=sgnf-hmmer&color=blue)](https://hub.docker.com/repository/docker/chasemc2/sgnf-hmmer) ![DockerImageSize(latestbydate)](https://img.shields.io/docker/image-size/chasemc2/sgnf-hmmer) ![DockerImageVersion(latestsemver)](https://img.shields.io/docker/v/chasemc2/sgnf-hmmer) ![DockerPulls](https://img.shields.io/docker/pulls/chasemc2/sgnf-hmmer)

[![DockerPulls](https://img.shields.io/static/v1?logo=docker&label=&message=sgnf-hmmer_plus&color=blue)](https://hub.docker.com/repository/docker/chasemc2/sgnf-hmmer_plus) ![DockerImageSize(latestbydate)](https://img.shields.io/docker/image-size/chasemc2/sgnf-hmmer_plus) ![DockerImageVersion(latestsemver)](https://img.shields.io/docker/v/chasemc2/sgnf-hmmer_plus) ![DockerPulls](https://img.shields.io/docker/pulls/chasemc2/sgnf-hmmer_plus)

[![DockerPulls](https://img.shields.io/static/v1?logo=docker&label=&message=sgnf-sgpy&color=blue)](https://hub.docker.com/repository/docker/chasemc2/sgnf-sgpy) ![DockerImageSize(latestbydate)](https://img.shields.io/docker/image-size/chasemc2/sgnf-sgpy) ![DockerImageVersion(latestsemver)](https://img.shields.io/docker/v/chasemc2/sgnf-sgpy) ![DockerPulls](https://img.shields.io/docker/pulls/chasemc2/sgnf-sgpy)

[![DockerPulls](https://img.shields.io/static/v1?logo=docker&label=&message=sgnf-antismash&color=blue)](https://hub.docker.com/repository/docker/chasemc2/sgnf-antismash) ![DockerImageSize(latestbydate)](https://img.shields.io/docker/image-size/chasemc2/sgnf-antismash) ![DockerImageVersion(latestsemver)](https://img.shields.io/docker/v/chasemc2/sgnf-antismash) ![DockerPulls](https://img.shields.io/docker/pulls/chasemc2/sgnf-antismash)

[![DockerPulls](https://img.shields.io/static/v1?logo=docker&label=&message=sgnf-minimal&color=blue)](https://hub.docker.com/repository/docker/chasemc2/sgnf-minimal) ![DockerImageSize(latestbydate)](https://img.shields.io/docker/image-size/chasemc2/sgnf-minimal) ![DockerImageVersion(latestsemver)](https://img.shields.io/docker/v/chasemc2/sgnf-minimal) ![DockerPulls](https://img.shields.io/docker/pulls/chasemc2/sgnf-minimal)

# Skip Setup and Launch on...

This pipeline can be launched directly from [![Launch on Nextflow Tower](https://img.shields.io/badge/Nextflow%20Tower-%234256e7)](https://tower.nf/launch?pipeline=https://github.com/socialgene/sgnf) or [![Run an example with Gitpod](https://img.shields.io/badge/Gitpod-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/socialgene/sgnf)


# Schema

![image](https://github.com/socialgene/sgnf/assets/18691127/36bcf534-3996-4b13-ba5d-f746830ada47)

