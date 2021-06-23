const { Client } = require('pg')
const Aws = require('aws-sdk')

async function createClient() {
    const sm = new Aws.SecretsManager()
    const result = await sm.getSecretValue({ SecretId: process.env.DB_CONFIG_SECRET_ID })
    const config = JSON.parse(result)
    return new Client(config)
}

async function createUser(metadata) {
    if (!metadata) {
        throw new Error('cannot create user: event "metadata" missing')
    }
    const username = metadata.username
    if (!username) {
        throw new Error('cannot create user: username is required')
    }
    const password = metadata.password
    if (!password) {
        throw new Error('cannot create user: password is required')
    }

    const client = await createClient()
    await client.connect()
    const res = await client.query(`CREATE USER $1 WITH PASSWORD $2`, [username, password.value])
    await client.end()
}

async function createDatabase(metadata) {
    if (!metadata) {
        throw new Error('cannot create database: event "metadata" missing')
    }
    const databaseName = metadata.databaseName
    if (!databaseName) {
        throw new Error('cannot create database: databaseName is required')
    }
    const owner = metadata.owner
    if (!owner) {
        throw new Error('cannot create database: owner is required')
    }

    const client = await createClient()
    await client.connect()
    const res = await client.query(`CREATE DATABASE $1 OWNER $2`, [databaseName, owner])
    await client.end()
}

exports.handler = async (event, context, callback) => {
    const input = event.payload
    switch (input.type) {
        case 'create-user':
            await createUser(input?.metadata)
            break
        case 'create-database':
            await createDatabase(input?.metadata)
            break
    }
}
