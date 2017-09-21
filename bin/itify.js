#!/bin/node

// import
const ArgumentParser = require('argparse').ArgumentParser;
const fs = require('fs');

const DESCRIBE_REGEX = /^[ \t]*describe\(.*$/;
const IT_REGEX = /^[ \t]*it\(.*$/;
const WHITE_LINE_REGEX = /^[ \t]*$/;

function itify(filePath, outPath) {
    const lines = fs.readFileSync(filePath, 'utf8').split('\n');

    let output = [];
    lines.forEach(function(line, i, lines) {
        //let i = 0;
        if (IT_REGEX.exec(lines[i]) && !DESCRIBE_REGEX.exec(lines[i - 1]) && !WHITE_LINE_REGEX.exec(lines[i - 1])) {
            output.push('');
        }
        output.push(lines[i]);
    });
    output = output.join('\n');

    fs.writeFileSync(outPath, output, 'utf8');
}

console.log(process.argv[2]);
console.log('\n\nKURWA!\n\n');

const parser = new ArgumentParser({
    version: '0.0.1',
    addHelp: true,
    description: 'Itify'
});
parser.addArgument('--verbose', { action: 'storeTrue' });
parser.addArgument('inputFile', { action: 'store', type: 'string' });

const args = parser.parseArgs();

const print = (function(verbose) {
    return function() {
        if (verbose) {
            console.log(...arguments);
        }
    };
})(args.verbose);

print('Processing', args.inputFile, '...');
itify(args.inputFile, args.inputFile);
print('...', args.inputFile, 'Processed.');
