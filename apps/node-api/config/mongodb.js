const { MongoClient } = require('mongodb');

const client = new MongoClient(process.env.MONGO_URI || 'mongodb://mongo:27017', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

async function connectMongoDB() {
    try {
        await client.connect();
        console.log('Connected to MongoDB');
        return client.db(process.env.MONGO_DB_NAME || 'your_mongo_database');
    } catch (error) {
        console.error('Failed to connect to MongoDB', error);
        process.exit(1);
    }
}

module.exports = connectMongoDB;
