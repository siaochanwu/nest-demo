import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserFilter } from './users.type';
import { UsersDto } from './dto/users.dto';
import { RolesService } from '../roles/roles.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly rolesService: RolesService,
  ) {}

  async findAll(query: UserFilter): Promise<User[]> {
    const where: any = {};
    if (query.id) where.id = query.id;
    if (query.username) where.username = query.username;
    if (query.email) where.email = query.email;
    if (query.name) where.name = query.name;
    if (query.mobile) where.mobile = query.mobile;
    
    return this.userRepository.find({ 
      where,
      relations: ['roles'],
    });
  }

  async findOne(id: number): Promise<User | null> {
    return this.userRepository.findOne({ 
      where: { id },
      relations: ['roles'],
    });
  }

  async findById(id: number): Promise<User | null> {
    return this.userRepository.findOne({ 
      where: { id },
      relations: ['roles'],
    });
  }

  async findByUsername(username: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { username },
      relations: ['roles'],
    });
  }

  async create(userDto: UsersDto): Promise<User> {
    const { roles: roleNames, ...userData } = userDto;
    const newUser = this.userRepository.create(userData);
    
    // Set default roles if not provided
    const defaultRoleNames = roleNames || ['user'];
    const roles = await this.rolesService.findByNames(defaultRoleNames);
    newUser.roles = roles;
    
    return this.userRepository.save(newUser);
  }

  async update(id: number, updateData: Partial<User>): Promise<User | null> {
    await this.userRepository.update(id, updateData);
    return this.findOne(id);
  }

  async remove(id: number): Promise<boolean> {
    const result = await this.userRepository.delete(id);
    return result.affected ? result.affected > 0 : false;
  }
}
