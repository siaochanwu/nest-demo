import { Injectable } from '@nestjs/common';
import { User, UserFilter } from './users.type';
import { UsersDto } from './dto/users.dto';

@Injectable()
export class UsersService {
  private users: User[] = [
    {
      id: 1,
      name: 'John',
      email: 'H2G6A@example.com',
      mobile: '1234567890',
      password: 'password',
    },
    {
      id: 2,
      name: 'wow',
      email: '5oQ0w@example.com',
      mobile: '9876543210',
      password: 'password',
    },
  ];

  findAll(query: UserFilter): User[] {
    if (query.id) {
      return this.users.filter((user) => user.id === query.id);
    }
    return this.users;
  }

  findOne(id: number): User | undefined {
    return this.users.find((user) => user.id === id);
  }

  create(userDto: UsersDto) {
    this.users.push(userDto);
    return this.users;
  }

  update(id: number, user: User) {
    return this.findOne(id);
  }

  remove(id: number) {
    return this.findOne(id);
  }
}
