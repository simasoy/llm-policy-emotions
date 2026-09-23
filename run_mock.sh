#!/usr/bin/env bash
# Runs the whole pipeline on fake data to check that everything works.
# Output goes to data/mock/ and results/mock/. Mock results mean nothing.
set -e
cd "$(dirname "$0")/src"
rm -rf ../data/mock ../results/mock
python build_prompts.py
python generate.py --mock
python lexicon.py --mock
python llm_coder.py --mock
python sample_for_coding.py --mock
python agreement.py --mock > /dev/null
python analyze.py --mock --source llm
python analyze.py --mock --source lexicon > /dev/null
echo "Mock pipeline OK. See results/mock/"
