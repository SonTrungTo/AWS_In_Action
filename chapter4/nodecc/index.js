const blessed = require('blessed');

const screen = blessed.screen({
    autoPadding: true,
    smartCSR: true,
    log: './nodecc.log'
});
screen.title = 'Node Control Center for AWS';

const content = blessed.box({
    border: {
        type: 'none',
        fg: '#ffffff'
    },
    parent: screen,
    width: '70%',
    height: '90%',
    top: '10%',
    left: '30%',
    fg: 'white',
    bg: 'blue',
    content: '{bold}Node Control Center for AWS{/bold}\n\nPlease select one of the actions from the left and press return.\n\nYou can always go back with the left arrow button.\n\nYou can terminate the application by pressing ESC or q.',
    tags: true
});

