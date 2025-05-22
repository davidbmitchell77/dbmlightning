import { LightningElement } from 'lwc';

export default class IframeDemo extends LightningElement {
    remoteSiteUrl = 'https://mapquest.com';
    iframeHeight = 700;
    iframeWidth = 1210;

    get lightningCardTitle() {
        return `iFrame Demo (${new URL(this.remoteSiteUrl).hostname.replace('www.', '')})`;
    }

    get remoteSites() {
        return [
            { label: 'Dow Jones Industrial Average', value: 'https://www.nyse.com/quote/index/DJI'           },
            { label: 'Flight Status',                value: 'https://beta.flightaware.com/live/airport/KSAN' },
            { label: 'FourKites',                    value: 'https://fourkites.com'                          },
            { label: 'IP Location',                  value: 'https://iplocation.com'                         },
            { label: 'MapQuest ',                    value: 'https://mapquest.com'                           },
            { label: 'Test Your Speed ',             value: 'https://speed.measurementlab.net'               },
            { label: 'Weather',                      value: 'https://ventusky.com'                           },
            { label: 'Wikipedia',                    value: 'https://en.wikipedia.org'                       }
        ];
    }

    handleChange(event) {
        this.remoteSiteUrl = event.detail.value;
    }
}