import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World wendy!';
  }

  getSomething(): string {
    return 'what a day!';
  }
}
