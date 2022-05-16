import { Controller, Inject } from '@tsed/di';
import { Returns, Summary } from '@tsed/schema';
import { Put } from '@tsed/schema';
import { FunctionsRepository, FunctionModel } from '@tsed/prisma';

@Controller('/functions')
export class FunctionsController {
    @Inject()
    protected service: FunctionsRepository;

    @Put('/')
    @Summary('Create a new function from the given code')
    @Returns(201, FunctionModel)
    putFunction(): Promise<FunctionModel> {
        return 'hello';
    }
}
