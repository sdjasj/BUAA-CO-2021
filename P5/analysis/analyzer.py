import zipfile
import shutil
import os
import os.path as osp
import re
import json
from enum import Enum
from abc import abstractmethod

__theory = {
    '5': {
        'forward': 107,
        'stall': 15,
        'by_class': {
            'cal_rr <~~ cal_rr': {
                'forward': 12,
                'stall': 0
            },
            'cal_rr <~~ cal_ri': {
                'forward': 6,
                'stall': 0
            },
            'cal_rr <~~ load': {
                'forward': 4,
                'stall': 2
            },
            'cal_rr <~~ lui': {
                'forward': 6,
                'stall': 0
            },
            'cal_rr <~~ jal': {
                'forward': 6,
                'stall': 0
            },
            'cal_ri <~~ cal_rr': {
                'forward': 6,
                'stall': 0
            },
            'cal_ri <~~ cal_ri': {
                'forward': 3,
                'stall': 0
            },
            'cal_ri <~~ load': {
                'forward': 2,
                'stall': 1
            },
            'cal_ri <~~ lui': {
                'forward': 3,
                'stall': 0
            },
            'cal_ri <~~ jal': {
                'forward': 3,
                'stall': 0
            },
            'br_r2 <~~ cal_rr': {
                'forward': 4,
                'stall': 2
            },
            'br_r2 <~~ cal_ri': {
                'forward': 2,
                'stall': 1
            },
            'br_r2 <~~ load': {
                'forward': 1,
                'stall': 2
            },
            'br_r2 <~~ lui': {
                'forward': 3,
                'stall': 0
            },
            'br_r2 <~~ jal': {
                'forward': 2,
                'stall': 0
            },
            'load <~~ cal_rr': {
                'forward': 6,
                'stall': 0
            },
            'load <~~ cal_ri': {
                'forward': 3,
                'stall': 0
            },
            'load <~~ load': {
                'forward': 2,
                'stall': 1
            },
            'load <~~ lui': {
                'forward': 3,
                'stall': 0
            },
            'load <~~ jal': {
                'forward': 3,
                'stall': 0
            },
            'store <~~ cal_rr': {
                'forward': 6,
                'stall': 0
            },
            'store <~~ cal_ri': {
                'forward': 3,
                'stall': 0
            },
            'store <~~ load': {
                'forward': 3,
                'stall': 1
            },
            'store <~~ lui': {
                'forward': 3,
                'stall': 0
            },
            'store <~~ jal': {
                'forward': 3,
                'stall': 0
            },
            'jr <~~ cal_rr': {
                'forward': 4,
                'stall': 2
            },
            'jr <~~ cal_ri': {
                'forward': 2,
                'stall': 1
            },
            'jr <~~ load': {
                'forward': 1,
                'stall': 2
            },
            'jr <~~ jal': {
                'forward': 2,
                'stall': 0
            }
        }
    },
    '6': {
        'forward': 3963,
        'stall': 449,
        'by_class': {
            'cal_rr <~~ cal_rr': {
                'forward': 507,
                'stall': 0
            },
            'cal_rr <~~ cal_ri': {
                'forward': 390,
                'stall': 0
            },
            'cal_rr <~~ mv_fr': {
                'forward': 78,
                'stall': 0
            },
            'cal_rr <~~ load': {
                'forward': 130,
                'stall': 65
            },
            'cal_rr <~~ lui': {
                'forward': 39,
                'stall': 0
            },
            'cal_rr <~~ jal': {
                'forward': 39,
                'stall': 0
            },
            'cal_rr <~~ jalr': {
                'forward': 39,
                'stall': 0
            },
            'cal_ri <~~ cal_rr': {
                'forward': 390,
                'stall': 0
            },
            'cal_ri <~~ cal_ri': {
                'forward': 300,
                'stall': 0
            },
            'cal_ri <~~ mv_fr': {
                'forward': 60,
                'stall': 0
            },
            'cal_ri <~~ load': {
                'forward': 100,
                'stall': 50
            },
            'cal_ri <~~ lui': {
                'forward': 30,
                'stall': 0
            },
            'cal_ri <~~ jal': {
                'forward': 30,
                'stall': 0
            },
            'cal_ri <~~ jalr': {
                'forward': 30,
                'stall': 0
            },
            'br_r1 <~~ cal_rr': {
                'forward': 104,
                'stall': 52
            },
            'br_r1 <~~ cal_ri': {
                'forward': 80,
                'stall': 40
            },
            'br_r1 <~~ mv_fr': {
                'forward': 16,
                'stall': 8
            },
            'br_r1 <~~ load': {
                'forward': 20,
                'stall': 40
            },
            'br_r1 <~~ lui': {
                'forward': 12,
                'stall': 0
            },
            'br_r1 <~~ jal': {
                'forward': 8,
                'stall': 0
            },
            'br_r1 <~~ jalr': {
                'forward': 8,
                'stall': 0
            },
            'br_r2 <~~ cal_rr': {
                'forward': 52,
                'stall': 26
            },
            'br_r2 <~~ cal_ri': {
                'forward': 40,
                'stall': 20
            },
            'br_r2 <~~ mv_fr': {
                'forward': 8,
                'stall': 4
            },
            'br_r2 <~~ load': {
                'forward': 10,
                'stall': 20
            },
            'br_r2 <~~ lui': {
                'forward': 6,
                'stall': 0
            },
            'br_r2 <~~ jal': {
                'forward': 4,
                'stall': 0
            },
            'br_r2 <~~ jalr': {
                'forward': 4,
                'stall': 0
            },
            'mv_to <~~ cal_rr': {
                'forward': 78,
                'stall': 0
            },
            'mv_to <~~ cal_ri': {
                'forward': 60,
                'stall': 0
            },
            'mv_to <~~ mv_fr': {
                'forward': 12,
                'stall': 0
            },
            'mv_to <~~ load': {
                'forward': 20,
                'stall': 10
            },
            'mv_to <~~ lui': {
                'forward': 6,
                'stall': 0
            },
            'mv_to <~~ jal': {
                'forward': 6,
                'stall': 0
            },
            'mv_to <~~ jalr': {
                'forward': 6,
                'stall': 0
            },
            'load <~~ cal_rr': {
                'forward': 195,
                'stall': 0
            },
            'load <~~ cal_ri': {
                'forward': 150,
                'stall': 0
            },
            'load <~~ mv_fr': {
                'forward': 30,
                'stall': 0
            },
            'load <~~ load': {
                'forward': 50,
                'stall': 25
            },
            'load <~~ lui': {
                'forward': 15,
                'stall': 0
            },
            'load <~~ jal': {
                'forward': 15,
                'stall': 0
            },
            'load <~~ jalr': {
                'forward': 15,
                'stall': 0
            },
            'store <~~ cal_rr': {
                'forward': 117,
                'stall': 0
            },
            'store <~~ cal_ri': {
                'forward': 90,
                'stall': 0
            },
            'store <~~ mv_fr': {
                'forward': 18,
                'stall': 0
            },
            'store <~~ load': {
                'forward': 45,
                'stall': 15
            },
            'store <~~ lui': {
                'forward': 9,
                'stall': 0
            },
            'store <~~ jal': {
                'forward': 9,
                'stall': 0
            },
            'store <~~ jalr': {
                'forward': 9,
                'stall': 0
            },
            'mul_div <~~ cal_rr': {
                'forward': 156,
                'stall': 0
            },
            'mul_div <~~ cal_ri': {
                'forward': 120,
                'stall': 0
            },
            'mul_div <~~ mv_fr': {
                'forward': 24,
                'stall': 0
            },
            'mul_div <~~ load': {
                'forward': 40,
                'stall': 20
            },
            'mul_div <~~ lui': {
                'forward': 12,
                'stall': 0
            },
            'mul_div <~~ jal': {
                'forward': 12,
                'stall': 0
            },
            'mul_div <~~ jalr': {
                'forward': 12,
                'stall': 0
            },
            'jalr <~~ cal_rr': {
                'forward': 22,
                'stall': 11
            },
            'jalr <~~ cal_ri': {
                'forward': 16,
                'stall': 8
            },
            'jalr <~~ mv_fr': {
                'forward': 4,
                'stall': 2
            },
            'jalr <~~ load': {
                'forward': 3,
                'stall': 6
            },
            'jalr <~~ jal': {
                'forward': 2,
                'stall': 0
            },
            'jalr <~~ jalr': {
                'forward': 2,
                'stall': 0
            },
            'jr <~~ cal_rr': {
                'forward': 22,
                'stall': 11
            },
            'jr <~~ cal_ri': {
                'forward': 16,
                'stall': 8
            },
            'jr <~~ mv_fr': {
                'forward': 4,
                'stall': 2
            },
            'jr <~~ load': {
                'forward': 3,
                'stall': 6
            },
            'jr <~~ jal': {
                'forward': 2,
                'stall': 0
            },
            'jr <~~ jalr': {
                'forward': 2,
                'stall': 0
            }
        }
    }
}

__classify = {
    'cal_rr': ['add', 'addu', 'sub', 'subu', 'slt', 'sltu', 'and', 'nor', 'or', 'xor', 'sllv', 'srav', 'srlv'],
    'cal_ri': ['addi', 'addiu', 'slti', 'sltiu', 'andi', 'ori', 'xori', 'sll', 'sra', 'srl'],
    'br_r1': ['bgez', 'bgtz', 'blez', 'bltz'],
    'br_r2': ['beq', 'bne'],
    'mv_fr': ['mfhi', 'mflo'],
    'mv_to': ['mthi', 'mtlo'],
    'load': ['lw', 'lh', 'lhu', 'lb', 'lbu'],
    'store': ['sw', 'sh', 'sb'],
    'mul_div': ['mult', 'multu', 'div', 'divu'],
    'lui': ['lui'],
    'jal': ['jal'],
    'jalr': ['jalr'],
    'jr': ['jr']
}


def classify(instr):
    for cls in __classify.keys():
        if instr in __classify[cls]:
            return cls
    assert False


def extract(path, file):
    split_file = file.split('.')
    file_name = '.'.join(split_file[:-1])
    with zipfile.ZipFile(f'{path}/{file}') as z:
        z.extractall(f'{path}/{file_name}')
    return file_name


class PipelineStage(Enum):
    D = 'd'
    E = 'e'
    M = 'm'
    W = 'w'

    @staticmethod
    def to_int(stage_name):
        return {
            PipelineStage.D: 1,
            PipelineStage.E: 2,
            PipelineStage.M: 3,
            PipelineStage.W: 4
        }[stage_name]

    @staticmethod
    def from_str(stage_str: str):
        for v in [PipelineStage.D, PipelineStage.E, PipelineStage.M, PipelineStage.W]:
            if stage_str.lower() == v.value:
                return v
        raise ValueError()

    @staticmethod
    def between(s1, s2):
        if str(s1) < str(s2):
            return list(filter(lambda stage: str(s1) < str(stage) < str(s2),
                               [PipelineStage.D, PipelineStage.E, PipelineStage.M, PipelineStage.W]))
        else:
            return PipelineStage.between(s2, s1)


class HazardInfo:
    def __hash__(self):
        return self.__str__().__hash__()

    def __eq__(self, other):
        return self.__str__() == other.__str__()

    @abstractmethod
    def to_dict(self):
        pass


class ForwardInfo(HazardInfo):
    def __init__(self, src_instr: str, dst_instr: str,
                 src_stage: PipelineStage, dst_stage: PipelineStage):
        self.src_instr = src_instr
        self.dst_instr = dst_instr
        self.src_stage = src_stage
        self.dst_stage = dst_stage

    def __str__(self):
        return f'({self.src_instr}, {self.dst_instr}, {self.src_stage}, {self.dst_stage})'

    def to_dict(self):
        return {
            'src_instr': self.src_instr,
            'dst_instr': self.dst_instr,
            'src_stage': self.src_stage.name,
            'dst_stage': self.dst_stage.name
        }


class StallInfo(HazardInfo):
    def __init__(self, d_instr: str, cause: str, interval: int):
        self.d_instr = d_instr
        self.cause = cause
        self.interval = interval if interval != -1 else None

    def __str__(self):
        return f'({self.d_instr}, {self.cause}, {self.interval})'

    def to_dict(self):
        return {
            'd_instr': self.d_instr,
            'cause': self.cause,
            'interval': self.interval
        }


def extract_hazard_json(path):
    def extract_instr(string):
        m = re.match(r'^(\w+).*$', string)
        if m is not None:
            return m.group(1)
        raise ValueError()

    def dict_to_forward(d):
        src_stage = PipelineStage.from_str(d['forward']['new']['stage'])
        dst_stage = PipelineStage.from_str(d['forward']['old']['stage'])
        src_instr = extract_instr(d['view'][src_stage.value]['instr'])
        dst_instr = extract_instr(d['view'][dst_stage.value]['instr'])
        return ForwardInfo(src_instr, dst_instr, src_stage, dst_stage)

    def dict_to_stall(d):
        __cause = d['cause']
        d_instr = extract_instr(d['view']['d']['instr'])
        if __cause != 'none':
            cause = extract_instr(d['view'][d['cause']]['instr'])
            interval = \
                PipelineStage.to_int(PipelineStage.from_str(d['cause'])) - PipelineStage.to_int(PipelineStage.D) - 1
            return StallInfo(d_instr, cause, interval)
        else:
            return None

    with open(path, 'r', encoding='utf-8') as hz_file:
        hazard_dict = dict(json.loads(hz_file.read()))
    valid_forward_iter = list(filter(lambda fwd: fwd['valid'], hazard_dict['forwarding']))
    forward_list = list(map(dict_to_forward, valid_forward_iter))
    stall_list = list(filter(lambda stl: stl is not None and stl.cause != 'm/d',
                             map(dict_to_stall, hazard_dict['stalling'])))
    return len(valid_forward_iter) / len(hazard_dict['forwarding']), forward_list, stall_list


def cal_grade(expect, stat):
    assert stat <= expect
    if expect == 0:
        assert stat == 0
        return None
    if stat == 0:
        return 0
    return 60 + 40 * (stat / expect)


if __name__ == '__main__':
    if not osp.isdir('result'):
        os.mkdir('result')
    jar_path = './Hazard-Calculator.jar'

    if not osp.isfile(jar_path):
        print('Hazard-Calculator NOT FOUND!')
        exit(1)

    testcase_sets = list(filter(lambda n: re.search(r'^P[56].*?\.zip$', n), os.listdir('work')))
    if len(testcase_sets) == 0:
        exit()

    run_choice = False
    for testcase_set in testcase_sets:
        f_name = extract('work', testcase_set)
        testcases = list(filter(lambda n: n.split('.')[-1] == 'zip', os.listdir(f'work/{f_name}')))
        case_names = []
        valid_ratio = []
        forward_st = set()
        stall_st = set()
        project_number = re.match(r'^P(.).*?\.zip$', testcase_set).group(1)
        print(f'->> READY {testcase_set} ~~ Project {project_number}')
        if not run_choice:
            __choice = input('->> Run this testcase? [Ya/Y/n]\n'
                             '    Ya: Yes for all of the left\n'
                             '     Y: Yes for this\n'
                             '     n: No for this\n'
                             '->> Choose: ')
            if __choice.lower() == 'ya':
                run_choice = True
            else:
                if __choice.lower() == 'n':
                    continue
                while __choice.lower() != 'y':
                    print(f'->> Illegal choice "{__choice}", ', end='')
                    __choice = input('choose again! [Ya/Y/n]')
                    if __choice.lower() == 'ya' or __choice.lower() == 'n':
                        break
                if __choice.lower() == 'ya':
                    run_choice = True
                if __choice.lower() == 'n':
                    continue
        if len(testcases) == 0:
            print('--> EMPTY! Check your zip-file!')
            continue
        for testcase in testcases:
            case_name = extract(f'work/{f_name}', testcase)
            print('--> RUNNING ' + case_name)
            case_names.append(case_name)
            os.system(f'java -jar {jar_path} "work/{f_name}/{case_name}/code.txt" --hz'
                      f' --im-base 0x3000 --im-size 16384 --dm-base 0 --dm-size 12288 1> out.tmp 2> err.tmp')
            with open('err.tmp', 'r', encoding='utf-8') as err:
                err_info = err.read()
                if err_info != '':
                    print(f'--> ERROR! Check {testcase_set}/{testcase}')
                    print(err_info)
                    exit(1)
            __valid, __forward, __stall = extract_hazard_json('hazard.json')
            valid_ratio.append(__valid)
            forward_st = forward_st.union(set(__forward))
            stall_st = stall_st.union(set(__stall))
            shutil.move('hazard.json', f'work/{f_name}/{case_name}/hazard.json')
        with open(f'result/{f_name}_statistic_hazard.json', 'w', encoding='utf-8') as hz_st:
            forward_result = sorted(list(map(lambda _fwd: _fwd.to_dict(), forward_st)),
                                    key=lambda d: (d['src_instr'], d['dst_instr'], d['src_stage'], d['dst_stage']))
            stall_result = sorted(list(map(lambda _stl: _stl.to_dict(), stall_st)),
                                  key=lambda d: (d['cause'], d['d_instr'], d['interval']))

            instr_sta = dict(map(lambda pair_key: (pair_key, [0, 0]),
                                 dict(__theory[project_number])['by_class'].keys()))
            for f in forward_result:
                k = f'{classify(f["dst_instr"])} <~~ {classify(f["src_instr"])}'
                assert k in instr_sta.keys()
                instr_sta[k][0] = instr_sta[k][0] + 1
            for s in stall_result:
                k = f'{classify(s["d_instr"])} <~~ {classify(s["cause"])}'
                assert k in instr_sta.keys()
                instr_sta[k][1] = instr_sta[k][1] + 1
            forward_grade_sta = dict(filter(lambda x: x[1] is not None,
                                            map(lambda t: (t, cal_grade(
                                                __theory[project_number]['by_class'][t]['forward'], instr_sta[t][0])),
                                                __theory[project_number]['by_class'].keys())))
            stall_grade_sta = dict(filter(lambda x: x[1] is not None,
                                          map(lambda t: (t, cal_grade(__theory[project_number]['by_class'][t]['stall'],
                                                                      instr_sta[t][1])),
                                              __theory[project_number]['by_class'].keys())))

            hz_st.write(json.dumps({
                'forward_valid_ratio': sum(valid_ratio) / len(valid_ratio),
                'forward_count': len(forward_result),
                'stall_count': len(stall_result),
                'forward_coverage': len(forward_result) / __theory[project_number]['forward'],
                'stall_coverage': len(stall_result) / __theory[project_number]['stall'],
                'grade': {
                    'forward': {
                        'average': sum(map(lambda grade: forward_grade_sta[grade],
                                           forward_grade_sta.keys())) / len(forward_grade_sta.keys()),
                        'warning': list(filter(lambda fk: forward_grade_sta[fk] == 0, forward_grade_sta.keys())),
                        'details': forward_grade_sta
                    },
                    'stall': {
                        'average': sum(map(lambda grade: stall_grade_sta[grade],
                                           stall_grade_sta.keys())) / len(stall_grade_sta.keys()),
                        'warning': list(filter(lambda sk: stall_grade_sta[sk] == 0, stall_grade_sta.keys())),
                        'details': stall_grade_sta
                    }
                },
                'forward': forward_result,
                'stall': stall_result
            }, indent=4))

    os.remove('out.tmp')
    os.remove('err.tmp')
