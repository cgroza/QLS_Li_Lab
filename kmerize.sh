sra="SRR1544693.fasta.gz"
name=$(basename $sra .fasta.gz)
zcat $sra | awk '/^[^\>].*$/ {
 for(i=0; i <= length($0)-24+1; i=i+1) {
	 printf "%s ", substr($0, i, 24)
	}
 print "";
 }' | gzip -c > ${name}_kmers.gz

