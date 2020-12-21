var inquirer = require('inquirer');
var fs = require('fs');

inquirer.prompt([
    {
        type: 'list',
        name: 'vcs',
        message: 'What\'s version control system?',
        choices: [
            'Gitlab',
            'Github'
        ]
    }
]).then(answers => {
    fs.writeFile(`${process.env.configDir}/vcs.log`, answers.vcs, function (err) {
        if (err) {
            console.log("Error! " + err);
        }
    });
}).catch(error => {
    if (error.isTtyError) {
        console.log("Couldn't render menu prompt!");
    } else {
        console.log("Something went wrong!");
    }
});