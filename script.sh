#!/bin/bash

# Project name
PROJECT_NAME=$0

# Check if the project name was provided
if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

# Create the project directory and navigate into it
mkdir $PROJECT_NAME
cd $PROJECT_NAME || exit

# Initialize a Node.js project
npm init -y

# Install Express, dotenv, and other necessary packages
npm install fastify dotenv eslint-plugin-drizzle drizzle-orm
npm i -D typescript @types/node

# Install TypeScript and its dependencies
npm install --save-dev typescript @types/node @types/express ts-node-dev

# Create the .editorconfig file
echo "root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true" > .editorconfig

# Install and configure Prettier
npm install --save-dev prettier
echo "{
  \"semi\": false,
  \"singleQuote\": true,
  \"tabWidth\": 2,
  \"trailingComma\": \"es5\",
  \"printWidth\": 80
}" > .prettierrc

# Install and configure ESLint
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin @typescript-eslint/eslint-plugin @typescript-eslint/parser
npx eslint --init

# Create the tsconfig.json file
echo "{
  \"compilerOptions\": {
    \"target\": \"es6\",
    \"module\": \"commonjs\",
    \"outDir\": \"./dist\",
    \"rootDir\": \"./src\",
    \"strict\": true,
    \"esModuleInterop\": true,
    \"skipLibCheck\": true,
    \"forceConsistentCasingInFileNames\": true
  },
  \"include\": [\"src\"],
  \"exclude\": [\"node_modules\"]
}" > tsconfig.json

# Create the project structure and files
mkdir src
echo "import fastify from 'fastify'
import 'dotenv/config'
const server = fastify()

const port = parseInt(process.env.PORT || '3000');

server.get('/', async (request, reply) => {
  return 'Hello World!'
})

server.listen({ port }, (err, address) => {
  if (err) {
    console.error(err)
  }
  console.log(`Server listening at ${address}`);
})" > src/index.ts

# Create the .env file
echo "PORT=3000" > .env

# Configure the package.json scripts
npx json -I -f package.json -e 'this.scripts={ "start": "node dist/index.js", "build": "tsc", "dev": "ts-node-dev src/index.ts", "lint": "eslint . --ext .ts" }'

# Initialize git and make the first commit
git init
echo "node_modules
dist" > .gitignore
git add .
git commit -m "Initial commit"

echo "Node.js project with Express, dotenv, EditorConfig, Prettier, ESLint, and TypeScript successfully configured!"

npm run dev
