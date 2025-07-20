import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Service } from './entities/service.entity';
import { CreateServiceDto, UpdateServiceDto } from './dto/service.dto';

@Injectable()
export class ServicesService {
  constructor(
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
  ) {}

  async findAll(): Promise<Service[]> {
    return this.serviceRepository.find();
  }

  async findActive(): Promise<Service[]> {
    return this.serviceRepository.find({ where: { isActive: true } });
  }

  async findOne(id: number): Promise<Service | null> {
    return this.serviceRepository.findOne({ where: { id } });
  }

  async create(createServiceDto: CreateServiceDto): Promise<Service> {
    const service = this.serviceRepository.create(createServiceDto);
    return this.serviceRepository.save(service);
  }

  async update(id: number, updateServiceDto: UpdateServiceDto): Promise<Service | null> {
    await this.serviceRepository.update(id, updateServiceDto);
    return this.findOne(id);
  }

  async remove(id: number): Promise<boolean> {
    const result = await this.serviceRepository.delete(id);
    return result.affected ? result.affected > 0 : false;
  }
}