import { Injectable } from '@nestjs/common';
import { User, UserFilter } from './users.type';
import { UsersDto } from './dto/users.dto';

@Injectable()
export class UsersService {
  private users: User[] = [
    {
      id: '1',
      name: 'John',
      email: 'H2G6A@example.com',
      mobile: '1234567890',
      password: 'password',
      username: 'john',
      roles: ['admin', 'user'],
    },
    {
      id: '2',
      name: 'wow',
      email: '5oQ0w@example.com',
      mobile: '9876543210',
      password: 'password',
      username: 'wow',
      roles: ['user'],
    },
  ];

  findAll(query: UserFilter): User[] {
    if (query.id) {
      return this.users.filter((user) => user.id === query.id);
    }
    return this.users;
  }

  findOne(id: string): User | undefined {
    return this.users.find((user) => user.id === id);
  }

  findById(id: string): Promise<User | undefined> {
    return Promise.resolve(this.users.find((user) => user.id === id));
  }

  findByUsername(username: string): Promise<User | undefined> {
    return Promise.resolve(
      this.users.find((user) => user.username === username),
    );
  }

  create(userDto: UsersDto) {
    const newUser: User = {
      ...userDto,
      roles: userDto.roles || ['user'],
    };
    this.users.push(newUser);
    return this.users;
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  update(id: string, user: User) {
    return this.findOne(id);
  }

  remove(id: string) {
    return this.findOne(id);
  }
}
