const { Client } = require('pg')
const Aws = require('aws-sdk')
const dbConfigSecretId = process.env.DB_CONFIG_SECRET_ID

async function getSecret(secretId) {
    const sm  = new Aws.SecretsManager()
    const request = sm.getSecretValue({ SecretId: secretId })
    const result = await request.promise()
    return JSON.parse(result.SecretString)
}

async function createDbClient() {
    const config = await getSecret(dbConfigSecretId)
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

    const client = await createDbClient()
    await client.connect()
    const res = await client.query(`CREATE USER "${username}" WITH PASSWORD '${password}'`)
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

    const client = await createDbClient()
    await client.connect()
    const res = await client.query(`CREATE DATABASE '${databaseName}' OWNER '${owner}'`)
    await client.end()
}

exports.handler = async function(event, context, callback) {
    switch (event.type) {
        case 'create-user':
            await createUser(event?.metadata)
            break
        case 'create-database':
            await createDatabase(event?.metadata)
            break
    }
}
