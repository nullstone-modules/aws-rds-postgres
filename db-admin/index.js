const { Client } = require('pg')
const Aws = require('aws-sdk')
const dbConfigSecretId = process.env.DB_CONFIG_SECRET_ID

async function getSecret(secretId) {
    const sm  = new Aws.SecretsManager()
    const request = sm.getSecretValue({ SecretId: secretId })
    const result = await request.promise()
    return JSON.parse(result.SecretString)
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

    const dbConfig = await getSecret(dbConfigSecretId)
    const client = new Client(dbConfig)
    await client.connect()

    // There is no "CREATE USER IF NOT EXISTS", check to see if it exists first
    const res = await client.query(`SELECT 1 FROM pg_roles WHERE rolname = '${username}'`)
    if (res && res.rows && res.rows.length > 0) {
        console.log(`User ${username} already exists`)
        return
    }

    await client.query(`CREATE USER "${username}" WITH PASSWORD '${password}'`)
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

    const dbConfig = await getSecret(dbConfigSecretId)
    const client = new Client(dbConfig)
    await client.connect()

    // There is no "CREATE DATABASE IF NOT EXISTS", check to see if it exists first
    const res = await client.query(`SELECT 1 FROM pg_database WHERE datname = '${databaseName}'`)
    if (res && res.rows && res.rows.length > 0) {
        console.log(`Database ${databaseName} already exists`)
        return
    }

    try {
        // In order to grant ownership of a database to another user, we must belong that user role
        // We don't want to be part of that role long-term, so revoke access once created
        console.log("Granting temporary access to user role")
        await client.query(`GRANT "${owner}" TO "${dbConfig.user}"`)
        console.log("Creating database, assigning owner to service user")
        await client.query(`CREATE DATABASE "${databaseName}" OWNER '${owner}'`)
    } finally {
        try {
            console.log("Revoking temporary access to user role")
            await client.query(`REVOKE "${owner}" FROM "${dbConfig.user}"`)
        } catch { }
    }
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
