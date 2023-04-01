
process DEDUPY {

    input:
    path x

    output:
    path "*$x" , emit: deduped

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = x.getSimpleName()

    """
    mkdir -p in
    mv $x in

    zcat in/$x |\
        sort |\
        uniq |
        gzip -6 > "$prefix"

    md5_as_filename.sh "$prefix" $x

    """
}
