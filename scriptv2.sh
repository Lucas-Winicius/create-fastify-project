#!/bin/bash

# Project name
PROJECT_NAME=$0

# Check if the project name was provided
if [ -z "$PROJECT_NAME" ]; then
  echo "Please provide a project name"
  exit 1
fi

# Create the project directory and navigate into it
mkdir $PROJECT_NAME
cd $PROJECT_NAME || exit

# Initialize a Node.js project
npm init -y
npx json -I -f package.json -e 'this.scripts={ "start": "node dist/index.js", "build": "tsc", "dev": "tsx watch src/server.ts", "lint": "eslint . --ext .ts" }'

# Install necessary packages
npm install fastify dotenv @fastify/cors
npm i -D typescript ts-node ts-node-dev @types/node eslint globals @eslint/js typescript-eslint prettier tsx tsc

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

echo "import globals from \"globals\";
import pluginJs from \"@eslint/js\";
import tseslint from \"typescript-eslint\";

export default [
  {languageOptions: { globals: globals.browser }},
  pluginJs.configs.recommended,
  ...tseslint.configs.recommended,
];" > eslint.config.mjs

echo "{
  \"semi\": false,
  \"singleQuote\": true,
  \"tabWidth\": 2,
  \"trailingComma\": \"es5\",
  \"printWidth\": 80
}" > .prettierrc

echo "root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true" > .editorconfig

mkdir src
mkdir src/routes
mkdir src/routes/home

echo "import fastify from 'fastify';
import 'dotenv/config';
import routes from './routes';
import cors from '@fastify/cors';

const port = parseInt(process.env.PORT || '3000');

export const app = fastify();

app.register(routes);
app.register(cors, {});

app.listen({ port }, (err, address) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(\`server listening on \${address}\`);
});" > src/server.ts

echo "import { app } from '../server';
import HomeRoutes from './home';

export default async function routes() {
    app.register(HomeRoutes)
}" > src/routes/index.ts

echo "import { app } from '../../server';
import get from './get';

export default async function HomeRoutes() {
    app.register(get)
}" > src/routes/home/index.ts

echo "import { FastifyReply, FastifyInstance, FastifyRequest } from 'fastify';

export default async function get(app: FastifyInstance) {
  app.get('/', (request: FastifyRequest, reply: FastifyReply) => {
    return reply.status(200).send('Hello World!');
  });
}
" > src/routes/home/get.ts

echo "PORT=3000" > .env

git init
echo "node_modules
dist" > .gitignore
git add .
git commit -m "Initial commit"

echo "Node.js project with Express, dotenv, EditorConfig, Prettier, ESLint, and TypeScript successfully configured!"

npm run dev
