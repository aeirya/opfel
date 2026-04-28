#!/usr/bin/env python3
import argparse
import sys
import ollama
import os

def log_input():
    with open('in.txt', 'w') as file:
        file.write('\t'.join(sys.argv))

def log_output(res):
    with open('out.txt', 'w') as file:
        file.write(res.response)

def parse_args():
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("-q", "--quiet", action="store_true")
    parser.add_argument("--no-color", action="store_true")
    parser.add_argument("--temperature", type=float, default=0)
    parser.add_argument("--seed", type=int, default=1)
    parser.add_argument("--max-tokens", type=int, dest="max_tokens")
    parser.add_argument("-s", "--system", default="")
    parser.add_argument("user_prompt", nargs="?")

    args, _ = parser.parse_known_args()
    prompt = args.user_prompt or sys.stdin.read()

    return args, prompt

def get_model():
    models = ['llama3.2:1b', 'gemma2:2b', 'qwen3.5:0.8b']
    model = os.environ.get('OPFEL_MODEL', 'llama3.2:1b')
    return model

def main():
    args, prompt = parse_args()
    model = get_model()

    res = ollama.generate(
        model = model,
        prompt = prompt,
        system = args.system,
        think=False,
        options=ollama.Options(
            num_predict=args.max_tokens,
            seed=args.seed,
            temperature=args.temperature,
        ),
        keep_alive='1m',
        format=None,
        stream=False, 
        raw=False,
        context=None,
    )

    print(res.response)
    exit(0)

if __name__ == "__main__":
    main()