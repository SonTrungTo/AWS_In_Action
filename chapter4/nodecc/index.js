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

const progress = blessed.progressbar({
    filled: 0,
    parent: screen,
    width: '70%',
    height: '10%',
    top: '0%',
    left: '30%',
    orientation: 'horizontal',
    border: {
        type: 'line',
        fg: '#ffffff'
    },
    fg: 'white',
    bg: 'blue',
    barFg: 'green',
    barBg: 'green'
});

const list = blessed.list({
    parent: screen,
    width: '30%',
    height: '100%',
    top: '0%',
    left: '0%',
    border: {
        type: 'line',
        fg: '#ffffff'
    },
    fg: 'white',
    bg: 'blue',
    selectedBg: 'green',
    mouse: true,
    keys: true,
    vi: true,
    label: 'actions',
    items: ['list virtual machines', 'create virtual machine', 'terminate virtual machine']
});
list.on('select', (el, i) => {
    content.border.type = 'line';
    content.focus();
    list.border.type = 'none';
    open(i);
    screen.render();
});
list.focus();

const open = (i) => {
    screen.log('open(' + i + ')');
    if (i === 0) {
        loading();
        require('./lib/listVMs')((err, instanceIds) => {
            loaded();
            if (err) {
                log('error', ' listVMs cb err ' + err);
            } else {
                const instanceList = blessed.list({
                    fg: 'white',
                    bg: 'blue',
                    selectedBg: 'green',
                    mouse: true,
                    keys: true,
                    vi: true,
                    items: instanceIds
                });
                content.append(instanceList);
                instanceList.focus();
                instanceList.on('select', (el, i) => {
                    loading();
                    require('./lib/showVM')(instanceIds[i], (err, instance) => {
                        loaded();
                        if (err) {
                            log('error', ' showVM cb err ' + err);
                        } else {
                            const vmContent = blessed.box({
                                fg: 'white',
                                bg: 'blue',
                                content:
                                    'InstanceId: ' + instance.InstanceId + '\n' +
                                    'InstanceType: ' + instance.InstanceType + '\n' +
                                    'LaunchTime: ' + instance.LaunchTime + '\n' +
                                    'ImageId: ' + instance.ImageId + '\n' +
                                    'PublicDnsName: ' + instance.PublicDnsName + '\n'
                            });
                            content.append(vmContent);
                        }
                        screen.render();
                    });
                });
                screen.render();
            }
            screen.render();
        });
    } else if (i === 1) {
        
    } else if (i === 2) {

    }
};

const loading = () => {

};

const loaded = () => {

};

const log = () => {

};