"""Static repository integrity checks; no MATLAB runtime required."""
from pathlib import Path
from zipfile import ZipFile, BadZipFile
import sys

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    'analysis/modeling/state.m',
    'analysis/modeling/transfer_function.m',
    'analysis/stability/root_locus.m',
    'controllers/pid/final_pid.m',
    'controllers/state_feedback/state_feedback.m',
    'controllers/nonlinear/nonlinearfinal.slx',
    'reports/project_report.pdf',
    'references/assignment_brief.pdf',
]


def main():
    absent = [path for path in REQUIRED if not (ROOT / path).is_file()]
    if absent:
        raise SystemExit('Missing required files: ' + ', '.join(absent))
    models = sorted(ROOT.rglob('*.slx'))
    if len(models) != 7:
        raise SystemExit(f'Expected 7 original .slx models, found {len(models)}')
    for path in models:
        try:
            with ZipFile(path) as archive:
                bad = archive.testzip()
                if bad:
                    raise ValueError(f'Corrupt entry: {bad}')
                if 'simulink/blockdiagram.xml' not in archive.namelist():
                    raise ValueError('Missing Simulink model XML')
        except (BadZipFile, ValueError) as exc:
            raise SystemExit(f'{path.relative_to(ROOT)}: {exc}') from exc
    for path in [ROOT / 'reports/project_report.pdf', ROOT / 'references/assignment_brief.pdf']:
        if path.read_bytes()[:5] != b'%PDF-':
            raise SystemExit(f'Invalid PDF header: {path}')
    print(f'Structure verified: {len(REQUIRED)} required files, {len(models)} intact Simulink archives.')


if __name__ == '__main__':
    main()
