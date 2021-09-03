### Preprocessing for the widely-distributed runs

1. take the task numbers/levels/coefficents from the single-group timers.json file of the run that you would like to reproduce, and put them in a text file, e.g. ctscheme_tl_full.txt
2. run ./scheme_to_json.py ctscheme_tl_full.txt -- this will produce a file ctscheme_tl_full.json
3. for each split that you would like to make, add another text file containing the task numbers/levels/coefficents (I took them from local strong scaling runs), call it e.g. ctscheme_system_1.txt
4. transform it to json with ./scheme_to_json.py ctscheme_system_1.txt
5. obtain the counterpart with ./scheme_split.py ctscheme_system_1.json ctscheme_system_0.json
6. validate that the two really fit together with ./scheme_validate_split.py ctscheme_system_1.json ctscheme_system_0.json
7. put those jsons in the right place and reference them in the ctparam files. Done!

