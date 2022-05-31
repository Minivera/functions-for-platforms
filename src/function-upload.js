const { promises } = require('fs');
const path = require('path');

const diskPath = `/etc/code`;

const hashContent = (content) => {
    let hash = 0;
    if (content.length === 0) {
        return hash;
    }

    let chr;
    for (let i = 0; i < content.length; i++) {
        chr = content.charCodeAt(i);
        hash = (hash << 5) - hash + chr;
        hash |= 0;
    }

    return hash;
};

module.exports = async function (context) {
    const fileContent = context.request.body.content;

    console.log(`Received function "${fileContent}", hashing.`);
    const fileHash = hashContent(fileContent);

    console.log(`Writing file ${fileHash}.js to the persistent disk`);
    await promises.writeFile(path.join(diskPath, `${fileHash}.js`), fileContent);

    return {
        status: 200,
        body: {
            message: 'function successfully uploaded',
            id: fileHash,
        },
    };
}
