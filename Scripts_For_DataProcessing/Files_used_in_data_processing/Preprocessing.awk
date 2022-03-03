{
    ks[$1 $2] = $3; # save the third column using the first and second as index
    k1[$1]++;       # save the first column
    k2[$2]++;       # save the second column
}
END {                                # After processing input
    for (j in k2) {                  # loop over the second column 
        printf ",%s", j;            # and print column headers
    };
    print "";                        # newline
    for (i in k1) {                  # loop over the first column 
        printf "%s", i;              # print it as row header
        for (j in k2) {              # loop over second again
            printf ",%s", ks[i j];  # and print values
        }
        print "";                    # newline
    }
}
